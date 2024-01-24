import { randomUUID } from 'crypto'
import { Subject } from 'rxjs'
import { collections, database } from '../appwrite'
import { AthleteInput } from '../models/inputs'
import { Athlete } from '../models/types'

export const athleteService = {
  athleteRegisteredSubject: new Subject<Athlete>(),

  async getAthletes(): Promise<Array<Athlete>> {
    const response = await database.listDocuments(collections.athletes)

    return response.documents.map((doc) => doc as any as Athlete)
  },

  async getAthleteById(id: string): Promise<Athlete> {
    const response = await database.getDocument(collections.athletes, id)

    return response as any as Athlete
  },

  async createAthlete(input: AthleteInput): Promise<Athlete> {
    const response = await database.createDocument(collections.athletes, randomUUID(), input)

    const athlete = response as any as Athlete

    athleteService.athleteRegisteredSubject.next(athlete)

    return athlete
  },
}
