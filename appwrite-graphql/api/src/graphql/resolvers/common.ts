import { ApiAthlete, ApiCountry, ApiDiscipline, ApiMedal, ApiResolver } from '../../models/api'
import { Athlete, Country, Discipline, Medal } from '../../models/types'
import { athleteService } from '../../services/athleteService'
import { countryService } from '../../services/countryService'
import { disciplineService } from '../../services/disciplineService'

export function getCountryResolver(code: string): ApiResolver<ApiCountry> {
  return async () => {
    const country = await countryService.getCountryByCode(code)

    return resolveCountry(country)
  }
}

export function getDisciplineResolver(disciplineCode: string): ApiResolver<ApiDiscipline> {
  return async () => {
    const discipline = await disciplineService.getDisciplinByCode(disciplineCode)

    return resolveDiscipline(discipline)
  }
}

export function getAthleteResolver(athleteId: string): ApiResolver<ApiAthlete> {
  return async () => {
    const athlete = await athleteService.getAthleteById(athleteId)

    return resolveAthlete(athlete)
  }
}

export function resolveAthlete(athlete: Athlete): ApiAthlete {
  return {
    id: athlete.$id,
    name: athlete.name,
    gender: athlete.gender,
    birthdate: athlete.birthdate,
    country: getCountryResolver(athlete.countryCode),
  }
}

export function resolveCountry(country: Country): ApiCountry {
  return {
    id: country.$id,
    name: country.name,
    code: country.code,
  }
}

export function resolveDiscipline(discipline: Discipline): ApiDiscipline {
  return {
    id: discipline.$id,
    name: discipline.name,
    code: discipline.code,
  }
}

export function resolveMedal(medal: Medal): ApiMedal {
  return {
    id: medal.$id,
    date: medal.date,
    event: medal.event,
    type: medal.type,
    athlete: getAthleteResolver(medal.athleteId),
    discipline: getDisciplineResolver(medal.disciplineCode),
  }
}
