import { Gender, MedalType } from './types'

export type ApiResolver<T> = () => Promise<T>

export type ApiAthlete = {
  id: string
  name: string
  gender: Gender
  birthdate: string
  country: ApiResolver<ApiCountry>
}

export type ApiMedal = {
  id: string
  date: string
  event: string
  type: MedalType
  athlete: ApiResolver<ApiAthlete>
  discipline: ApiResolver<ApiDiscipline>
}

export type ApiCountry = {
  id: string
  name: string
  code: string
}

export type ApiDiscipline = {
  id: string
  name: string
  code: string
}
