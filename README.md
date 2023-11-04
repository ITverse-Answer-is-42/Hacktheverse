# GeoPulse - Mapping Health, One Breath at a Time.

## Overview
Welcome to GeoPulse, an innovative application that empowers users with valuable insights into air quality and socio-economic factors for cities and countries worldwide. GeoPulse features a versatile front-end, offering both web and mobile applications, powered by a robust back-end system. With GeoPulse, you can easily access air quality data and explore how it relates to socio-economic indicators.

## Features

### Feature 1: Air Quality Metrics
- **Air Quality Index (AQI):** GeoPulse uses a generic color scheme to represent air quality for enhanced user understanding.
- **Top 10 Polluted Cities:** Stay informed about the top 10 most polluted cities globally, sourced from the IQAir API's AQI data. Our dynamic and visually appealing representation includes user-friendly filters and sorting options.
- **Top 10 Cleanest Cities:** Discover the top 10 cleanest cities worldwide based on the latest IQAir API's AQI data. Our feature includes an enhanced user experience with filters and sorting options.
- **Search by City/Country:** GeoPulse features an intuitive search bar with auto-complete functionality, making it easy to access air quality data for specific cities or countries.
- **Comparative Analysis:** Compare air quality data for at least two cities, visualized side by side or overlaying data on a single chart or graph. We use key air quality metrics, such as AQI, PM2.5 levels, PM10 levels, and ozone levels for comparison.

### Feature 2: Socio-Economic Factors
Enhance your engagement with socio-economic data for countries associated with the cities in our air quality data. We provide the following indicators:
- Total GDP
- GDP Per Capita
- GDP Growth
- Total Population
- Population Growth

### Feature 3: Interactive Map Integration
- Visualize air quality and socio-economic data on an interactive map.
- Combining location-based information from the AirQuality API with geographical representations, you can gain valuable insights into air quality and its correlation with socio-economic factors in different regions.
- Key Components:
  - Map API Integration: We have integrated [Google map](https://developers.google.com/maps) as our map API of choice.
  - Geospatial Data Overlay: Overlay air quality data onto the map, providing real-time markers or visual indicators on specific locations based on the air quality API. Different colors or icons represent air quality levels, allowing users to quickly grasp the information.
  - Socio-Economic Data Filters: Our user-friendly filters allow you to customise your map view, focusing on specific socio-economic indicators or air quality metrics. You can filter by GDP per capita, view only cities with particular air quality ranges, or explore population growth in a certain region.

## Backend
- Our back-end system applies data processing and transformation techniques to combine air quality data with socio-economic indicators.
- We ensure data consistency and accuracy through rigorous validation and quality checks.
- We provide well-documented API endpoints that the frontend (web or mobile) can use to request data, ensuring readiness to handle user queries.

## Frontend
We've designed an engaging and user-friendly interface suitable for the Android platform.

## Getting Started
1. Clone this repository in your local development environment.
2. Follow the setup instructions provided in the repository to start working on the project.

# API Documentation

This documentation outlines the usage and functionality of the Air Quality Index (AQI) API endpoint, which provides information on air quality.

## Endpoint

- **URL**: `localhost:4000/api/v1/aqi`
- **HTTP Method**: GET

## Query Parameters

- `view` (Optional): Specify the view for AQI data retrieval. Only accepts "top" or "worst" as values.
- `lat` (Optional): Latitude coordinate for location-based data retrieval.
- `long` (Optional): Longitude coordinate for location-based data retrieval.
- `country` (Optional): Specify the country for AQI data retrieval.

## Controller Logic

- Depending on the provided query parameters, the controller performs the following actions:
  - If `view` is provided with the value "top" or "worst," it retrieves the top or worst cities' AQI data.
  - If `lat` and `long` are provided, it retrieves AQI data based on latitude and longitude.
  - The controller also extracts the last word from the `country` parameter and retrieves additional data, including position air index and Social Economic factors.

## Response

The API responds with a JSON object with the following structure:

- `status`: A string indicating the status of the response, set to 'success'.
- `cities`: An array of AQI data. If multiple cities are retrieved, they are contained in an array.
- `positionAirIndex`: An array of position air index data.
- `socialEconomicFactors`: Five arrays of social economic factors data.


## Endpoint

- **URL**: `localhost:4000/api/v1/markers`
- **HTTP Method**: GET

## Query Parameters

- `lat` (Required): Latitude coordinate for location-based data retrieval.
- `long` (Required): Longitude coordinate for location-based data retrieval.
- `query` (Optional): Specify the query type, which can be one of the following:
  - `AQI` (Air Quality Index)
  - `GDP/Capita` (Gross Domestic Product per Capita)
  - `Total Population`
  - `Total GDP`
  - `GDP Growth Rate`
  - `Population Growth`
- `min` (Optional): Minimum value for the specified query.
- `max` (Optional): Maximum value for the specified query.

## Controller Logic

- The controller takes the provided parameters and retrieves marker data based on location (latitude and longitude).
- It calculates the distance between the provided coordinates and the markers from the data.
- For markers within 100 units of distance, it sends a request to the AQI API to get air quality information.
- It also extracts the country information and makes a request to get Social Economic Factors (SEF) based on the country.
- The controller filters and processes the data based on the query type and value range, if provided.

## Response

The API responds with a JSON array containing marker information, which includes:
- `lat`: Latitude of the marker.
- `long`: Longitude of the marker.
- `aqi`: Air Quality Index value.
- `country`: Country information.
- Additional values based on the specified query type:
  - `gdp`: Gross Domestic Product per Capita.
  - `population`: Total Population.
  - `tgdp`: Total GDP.
  - `populationGrowth`: Population Growth.
  - `gdpGrowthRate`: GDP Growth Rate.

The response data is filtered and processed based on the provided query and value range.


## Contributors
- [Nowshin Alam Owishi](https://github.com/owishiboo)
- [Moksedur Rahman Sohan](https://github.com/ShikariSohan)
- [Muhit Mahmud](https://github.com/201833113)
