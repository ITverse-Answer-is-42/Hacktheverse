const appError = require("../utils/appError");
const catchAsync = require("../utils/catchAsync");
const axios = require("axios");
const allCountries = require("../utils/allCountries"); 
const SEF = require("../model/SEF");
const data = require("../utils/cityDetails.json");
const countries = require("../utils/countryLatLong.json");

exports.getAqi = catchAsync(async (req, res, next) => {
  const { view, lat, long , country} = req.query;

  let data,sef;

  if (view) {
    // Get AQI data based on 'view'
    data = await getRanking(view);
  } else if (lat && long) {
    // Get AQI data based on latitude and longitude
    data = await getDataWithLatLong(lat, long);
    const location = country;
    const words = location.split(' '); 
    const lastWord = words[words.length - 1]; 
    sef = await getSEFwithCountry(lastWord);
    
  } else {
    // Get current AQI data if no specific parameters are provided
    data = await getCurrent();
  }

  // Prepare the response
  const response = {
    status: 'success',
    cities: Array.isArray(data) ? data : [data],
    tgdp : sef ? sef.tgdp : [],
    gdpCapita : sef ? sef.gdpCapita : [],
    gdpGrowthRate : sef ? sef.gdpGrowthRate : [],
    tpopulation : sef ? sef.tpopulation : [],
    populationGrowth : sef ? sef.populationGrowth : [],
  };

  res.status(200).json(response);
});

const getRanking  = async (view)  => {
    if(!view) return;
    if(view !== "top" && view !== "worst") return;

    const page = 1;
    const perPage = 20;
    const sortBy = "aqi";
    const sortOrder = view === "top" ? "asc" : "desc";
    const AQI = "US";
    const url = `https://website-api.airvisual.com/v1/countries/rankings?sortBy=${sortBy}&sortOrder=${sortOrder}&page=${page}&perPage=${perPage}&AQI=${AQI}`;
    const response = await axios.get(url);
    const data = response.data;
    return data;
}

const getAllCitiesInfo = async (data) => {
    let allInfoPromies = [];
    for(let i = 0; i < data.length; i++) {
      const city = data[i].city;
      const country = data[i].country;
     
        
      const url = `https://api.waqi.info/feed/${city}/?token=${process.env.AQI_API_KEY}`
    //   const info =  getCityInfo(city, country);
      const info = axios.get(url);
      allInfoPromies.push(info);
    }
    const allInfo = await Promise.all(allInfoPromies);
    let datas = [];
    for(let i = 0; i < allInfo.length; i++) {
        if(allInfo[i].data.status !== 'ok') continue;
        const newData = allInfo[i].data.data;
        datas.push({
            ...data[i],
            "dominantPol" : newData.dominantPol,
            "forecast":extractForecast(newData.forecast)
            
        });
    }
   

    return datas;
}


const getCurrent = async ()=>{
    const url = `https://api.waqi.info/feed/here/?token=${process.env.AQI_API_KEY}`
    const info = await axios.get(url);
  
    const data = {
        aqi : info.data.data.aqi,
        dominentpol: info.data.data.dominantPol,
        forecast:extractForecast(info.data.data.forecast)
    }
    return data;
}

const getDataWithLatLong = async (lat, long) => {
    const url = `https://api.waqi.info/feed/geo:${lat};${long}/?token=${process.env.AQI_API_KEY}`
    const info = await axios.get(url);
    let d =  info.data.data;
    const data = {
        aqi : d.aqi,
        dominentpol: d.dominantPol,
        forecast:extractForecast(d.forecast)
    }
    return data;
}

const extractForecast = (forecastData)=>{
    let result = {}
for (const property in forecastData.daily) {
    const data = forecastData.daily[property];
  
    const latestDay = data[data.length - 1];
  
    const latestAvg = latestDay.avg;
  
    result[property] = latestAvg;
  }
  
  const forecast = result;
 
  return result;
}



const getSEFwithCountry = async (country) => {

    const regex = new RegExp(country, "i");
  
    const sef = await SEF.findOne({ name: regex});
    return sef;
}

exports.getMarkers = catchAsync(async (req, res, next) => {
  const { lat,long,query,min,max  } = req.query;
  
  
  const markers = [];
  const onlyCountries = [];


  

  for(let i = 0; i < data.length; i++) {
    const lat1 = data[i].lat;
    const long1 = data[i].lng;
    const distance = haversineDistance(lat1, long1, lat, long);
    if(distance > 100) continue;
    const city = data[i].city;
    const country = data[i].country;
    onlyCountries.push(country);
    const url = `https://api.waqi.info/feed/geo:${lat1};${long1}/?token=${process.env.AQI_API_KEY}`
    const info = axios.get(url);
    markers.push(info);
  }


  const allInfo = await Promise.all(markers);

  const response = [];
  for(let i = 0; i < allInfo.length; i++) {
    if(allInfo[i].data.status !== 'ok') continue;
    
    const newData = allInfo[i].data.data;
    const country = onlyCountries[i];

    const sef = await getSEFwithCountry(country);

    const gdp = sef ? sef.gdpCapita[0].value : 0;
    const population = sef ? sef.tpopulation[0].value : 0;
    const tgdp = sef ? sef.tgdp[0].value : 0;
    const populationGrowth = sef ? sef.populationGrowth[0].value : 0;
    const gdpGrowthRate = sef ? sef.gdpGrowthRate[0].value : 0;

    if(min && max) {
      if(query === "AQI") {
        if(newData.aqi < min || newData.aqi > max) continue;
      }
      else if(query === "GDP/Capita") {
        if(gdp < min || gdp > max) continue;
      }
      else if(query === "Total Population") {
        if(population < min || population > max) continue;
      }
      else if(query === "Total GDP") {
        if(tgdp < min || tgdp > max) continue;
      }
      else if(query === "GDP Growth Rate") {
        if(populationGrowth < min || populationGrowth > max) continue;
      }
      else if(query === "Population Growth") {
        if(gdpGrowthRate < min || gdpGrowthRate > max) continue;
      }
    }

    response.push({
      lat: newData.city.geo[0],
      long: newData.city.geo[1],
      aqi: newData.aqi,
    
      country:country,
      gdp,
      population,
      tgdp,
      populationGrowth,
      gdpGrowthRate
    });
  }
  const unique = getUniqueObjects(response);
  const setData = [];
  for(const property in unique) {
    setData.push(unique[property]);
  }
 
  console.log(setData.length);
  res.status(200).json(setData);
});

function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth radius in kilometers

  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;

  const a = Math.sin(dLat / 2) ** 2 + Math.cos(Math.PI / 180 * lat1) * Math.cos(Math.PI / 180 * lat2) * Math.sin(dLon / 2) ** 2;
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c;
}

function getUniqueObjects(objects) {
  const uniqueObjects = {};

  for (const object of objects) {
    const objectKey = JSON.stringify(object);

    if (!uniqueObjects[objectKey]) {
      uniqueObjects[objectKey] = object;
    }
  }

  return uniqueObjects;
}