const appError = require("../utils/appError");
const catchAsync = require("../utils/catchAsync");
const axios = require("axios");
const allCountries = require("../utils/allCountries"); 
const SEF = require("../model/SEF");

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
      console.log("city", city);
        console.log("country", country);
        
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
        console.log(newData)
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
    console.log(info.data.data)
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
  
  console.log(forecast);
  return result;
}

const getSEFwithCountry = async (country) => {
    // regex to match country name
    const regex = new RegExp(country, "i");
    console.log(country);
    const sef = await SEF.findOne({ name: regex});
   
    return sef;
}