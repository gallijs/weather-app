import React, { useEffect, useState } from 'react'
import queryString from 'qs'
import { debounce } from 'lodash'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faLocationArrow, faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons'
import './styles.css'


const UNITS = {
    'f': 'imperial',
    'c': 'metric'
}

/* This component will handle the fetch requests and data parsing */
const WeatherAppContainer = () => {
    const [forecast, setForecast] = useState({})
    const [location, setLocation] = useState('')
    const [unit, setUnit] = useState('f')
    const [cached, setCached] = useState(false)

    const condensedForecast = forecast?.weather_conditions?.reduce((acc, condition) => {
        const day = new Date(condition.date).toDateString()
        acc[day] = condition

        return acc
    }, {})

    const updateInput = (event: React.ChangeEvent<HTMLInputElement>) => {
        setLocation(event.target.value)
    }

    const toggleUnit = () => {
        unit === 'f' ? setUnit('c') : setUnit('f')
    }

    const fetchCurrentLocation = () => {
        navigator.geolocation.getCurrentPosition(async (result) => {
            const { latitude, longitude } = result.coords

            const url = `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${latitude}&longitude=${longitude}&localityLanguage=en`
            const response = await fetch(url)
            const geocoded = await response.json()

            setLocation(`${geocoded.city}, ${geocoded.countryCode}`)
        })
    }

    // Fetch forecast
    useEffect(() => {
        const fetchData = async () => {
            const params = queryString.stringify({
                forecast: {
                    location: location || 'San Francisco',
                    units: UNITS[unit],
                }
            })
            const url = `/forecast?${params}`
            const response = await fetch(url)
            const json = await response.json()

            // Set the forecast if the API responds successfully
            if (response.status === 200) {
                setForecast(json.forecast)
                setCached(json.cached)
            }
        }
        fetchData()
    }, [location, unit])

    const main = forecast?.weather_conditions?.[0]
    if (!main) return null

    return (
        <div className="container">
            <div className="weather-side">
                <div className="weather-gradient"></div>
                <div className="date-container">
                    <h2 className="date-dayname">{new Date(main?.date).toLocaleDateString('en', { weekday: 'long' })}</h2><span className="date-day">{new Date(main?.date).toLocaleDateString('en', { year: 'numeric', month: 'long', day: 'numeric' })}</span><i className="location-icon" ></i><span className="location">{forecast?.city?.name}, {forecast?.city?.country}</span>
                </div>
                <div className="weather-container"><i className="weather-icon" ></i>
                    <h1 className="weather-temp">{parseInt(main?.temperature)}°</h1>
                    <h3 className="weather-desc">{main?.description}</h3>
                </div>
            </div>
            <div className="info-side">
                <div className="today-info-container">
                    <div className="today-info">
                        <div className="precipitation">
                            <span className="title">CACHED</span><span className="value">{cached ? 'True' : 'False'}</span>
                            <div className="clear"></div>
                        </div>
                        <div className="humidity">
                            <span className="title">HIGH</span><span className="value">{parseInt(main?.temperature_high)}°</span>
                            <div className="clear"></div>
                        </div>
                        <div className="wind">
                            <span className="title">LOW</span><span className="value">{parseInt(main?.temperature_low)}°</span>
                            <div className="clear"></div>
                        </div>
                    </div>
                </div>
                <div className="week-container">
                    <ul className="week-list">
                        {Object.values(condensedForecast).slice(1, 6).map((weatherCondition) => (
                            weatherCondition &&
                            <li key={weatherCondition?.date}>
                                <span className="day-name">{new Date(weatherCondition.date).toLocaleDateString('en', { weekday: 'short' })}</span>
                                <span className="day-temp">{parseInt(weatherCondition.temperature)}°</span>
                            </li>
                        ))}
                        <div className="clear"></div>
                    </ul>
                </div>
                <div className="location-container">
                    <div id="search">
                        <input id="search" type="text" name="location" placeholder="San Francisco" onChange={debounce(updateInput, 250)} />
                        <FontAwesomeIcon icon={faMagnifyingGlass} />
                    </div>
                    <nav>
                        <button id="locateBtn" onClick={fetchCurrentLocation}>
                            <FontAwesomeIcon icon={faLocationArrow} />
                        </button>
                        <button id="unitBtn" onClick={toggleUnit}>°{unit}</button>
                    </nav>
                </div>
            </div>
        </div>)
}

export default WeatherAppContainer
