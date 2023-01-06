import React from 'react'
import { createRoot } from 'react-dom/client'
import WeatherContainer from './WeatherContainer'

const App = () => {
  return (<WeatherContainer />)
}

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('root')
  const root = createRoot(container)
  root.render(<App />)
})

export default App
