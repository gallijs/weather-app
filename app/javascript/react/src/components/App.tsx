import React from 'react'
import { createRoot } from 'react-dom/client'
import WeatherAppContainer from './WeatherAppContainer'

const App = () => {
  return (<WeatherAppContainer />)
}

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('root')
  const root = createRoot(container)
  root.render(<App />)
})

export default App
