const mongoose = require("mongoose");
const axios = require("axios");
const SEF = require("../model/SEF");

const DB = "mongodb://localhost:27017/mqi";

mongoose
  .connect(DB)
  .then(() => {
    console.log("MONGODB connected successfully".brightCyan);
    fetchDataAndSaveToDatabase();
  })
  .catch((err) => {
    console.log("Database connection unsuccessful!".red, err);
  });

const fetchDataAndSaveToDatabase = async () => {
  const {allCountries} = require("../utils/allCountries");

  for (const country of allCountries) {
    console.log(`Fetching data for ${country.name} (${country.code})`);

    const indicators = [
      "NY.GDP.MKTP.CD",
      "NY.GDP.MKTP.KD.ZG",
      "SP.POP.TOTL",
      "SP.POP.GROW",
      "NY.GDP.PCAP.CD",
    ];

    const dataPromises = indicators.map(async (indicator) => {
      const url = `https://api.worldbank.org/v2/countries/${country.code}/indicators/${indicator}?format=json`;
      const response = await axios.get(url);
      const [metaData, countryData] = response.data;

      if (countryData) {
        return {
          indicator,
          data: transformData(countryData),
        };
      } else {
        return null;
      }
    });

    const fetchedData = await Promise.all(dataPromises);

    const sefData = {
      name: country.name,
      country: country.code,
    };

    fetchedData.forEach((entry) => {
      if (entry) {
        sefData[entry.indicator] = entry.data;
      }
    });

    const sef = new SEF(sefData);
    await sef.save();
    console.log(`Data for ${country.name} saved.`);
  }

  mongoose.connection.close();
};

const transformData = (countryData) => {
  const sortedCountryData = countryData
    .filter((item) => item.value !== null)
    .sort((a, b) => b.date - a.date)
    .slice(0, Math.min(50, countryData.length));

  return sortedCountryData.map((item) => ({
    year: item.date,
    value: item.value,
  }));
};
