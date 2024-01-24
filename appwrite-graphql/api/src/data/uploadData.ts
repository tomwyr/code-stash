import { collections, database } from '../appwrite'
import { Athlete, Country, Discipline, Medal } from '../models/types'
import { OlympicsData } from './olympicsData'

export async function uploadData(olympicsData: OlympicsData) {
  for (const country of olympicsData.countries) {
    const countryData: Country = { ...country }
    delete countryData.$id

    await database.createDocument(collections.countries, country.$id, countryData)
  }

  for (const discipline of olympicsData.disciplines) {
    const disciplineData: Discipline = { ...discipline }
    delete disciplineData.$id

    await database.createDocument(collections.disciplines, discipline.$id, disciplineData)
  }

  for (const athlete of olympicsData.athletes) {
    const athleteData: Athlete = { ...athlete }
    delete athleteData.$id

    await database.createDocument(collections.athletes, athlete.$id, athleteData)
  }

  for (const medal of olympicsData.medals) {
    const medalData: Medal = { ...medal }
    delete medalData.$id

    await database.createDocument(collections.medals, medal.$id, medalData)
  }
}
