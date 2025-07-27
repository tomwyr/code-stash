import { Athlete, Country, Discipline, Medal } from '../models/types'

export type OlympicsData = {
  countries: Array<Country>
  disciplines: Array<Discipline>
  athletes: Array<Athlete>
  medals: Array<Medal>
}
