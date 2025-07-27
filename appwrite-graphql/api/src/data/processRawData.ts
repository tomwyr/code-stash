import { randomUUID } from 'crypto'
import { default as athletesJson } from './raw/athletes.json'
import { default as medalsJson } from './raw/medals.json'
import { Athlete, Country, Discipline, Gender, Medal, MedalType } from '../models/types'
import { OlympicsData } from './olympicsData'

export function processRawData(): OlympicsData {
  const countriesMap = new Map<String, Country>()
  const disciplinesMap = new Map<String, Discipline>()

  athletesJson.forEach((json) => {
    countriesMap.set(json.country_code, {
      $id: randomUUID(),
      code: json.country_code,
      name: json.country,
    })
  })

  medalsJson.forEach((json) => {
    disciplinesMap.set(json.discipline_code, {
      $id: randomUUID(),
      code: json.discipline_code,
      name: json.discipline,
    })
  })

  const countries = Array.from(countriesMap.values())
  const disciplines = Array.from(disciplinesMap.values())

  const athletes = athletesJson.map<Athlete>((json) => {
    const athlete: Athlete = {
      $id: randomUUID(),
      name: json.name,
      gender: Gender[json.gender],
      birthdate: json.birth_date.substring(0, 10),
      countryCode: json.country_code,
    }

    return athlete
  })

  const medals = medalsJson.map<Medal>((json) => {
    const medal: Medal = {
      $id: randomUUID(),
      date: json.medal_date.substring(0, 10),
      event: json.event,
      type: MedalType[json.medal_type],
      athleteId: athletes.find((value) => {
        return value.name == json.athlete_name
      }).$id,
      disciplineCode: json.discipline_code,
    }

    return medal
  })

  return {
    countries: countries,
    disciplines: disciplines,
    athletes: athletes,
    medals: medals,
  }
}
