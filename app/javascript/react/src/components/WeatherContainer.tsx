import React, { useEffect, useState } from 'react'
import queryString from 'qs'

/* This component will handle the fetch requests and data parsing */
const WeatherContainer = () => {
  const [forecast, setForecast] = useState({})

  // Fetch forecast
  useEffect(() => {
    const fetchData = async () => {
      const params = queryString.stringify({
        forecast: {
          location: 'San Francisco'
        }
      })
      const url = `/forecast?${params}`
      const response = await fetch(url)
      const json = await response.json()
      setForecast(json.forecast)
    }
    fetchData()
  }, [])

  const main = forecast?.weather_conditions?.[0]
  if (!main) return null

  return (
    <div>
      <div id="current" className="wrapper">
        {/* TODO: Create presentational component for the forecast */}
        <h1 className="location">{forecast?.city?.name}, {forecast?.city?.country}</h1>
      </div>
    </div>
  )
}

export default WeatherContainer
