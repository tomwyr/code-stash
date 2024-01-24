import { Gender, MedalType } from './types'

export type AthleteInput = {
  name: string
  gender: Gender
  birthdate: string
  countryCode: string
}

export type MedalInput = {
  event: string
  type: MedalType
  disciplineCode: string
  athleteId: string
}
