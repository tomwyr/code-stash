import { randomUUID } from 'crypto'
import { Subject } from 'rxjs'
import { collections, database } from '../appwrite'
import { MedalInput } from '../models/inputs'
import { Medal, MedalType } from '../models/types'

export const medalService = {
  medalAwardedSubject: new Subject<Medal>(),

  async getMedals(): Promise<Array<Medal>> {
    const response = await database.listDocuments(collections.medals)

    return response.documents.map((doc) => doc as any as Medal)
  },

  async createMedal(input: MedalInput): Promise<Medal> {
    const date = new Date(Date.now()).toISOString().substring(0, 10)

    const data = {
      ...input,
      date: date,
    }

    const response = await database.createDocument(collections.medals, randomUUID(), data)

    const medal = response as any as Medal

    medalService.medalAwardedSubject.next(medal)

    return medal
  },

  async *observeMedalAwarded(): AsyncIterable<Medal> {
    const medalAwards = Array.from(mockMedalAwards)

    while (medalAwards.length > 0) {
      await new Promise((f) => setTimeout(f, 3000))

      yield medalAwards.shift()
    }
  },
}

const mockMedalAwards: Array<Medal> = [
  {
    $id: randomUUID(),
    date: '2020-01-08',
    event: "Men's Freeski Halfpipe",
    type: MedalType.Silver,
    athleteId: '7c2ecee0-74d4-4e8f-b8cc-c5b8bec7a6b8',
    disciplineCode: 'FSK',
  },
  {
    $id: randomUUID(),
    date: '2020-03-11',
    event: 'Men',
    type: MedalType.Gold,
    athleteId: '10fb370f-3565-44c0-8643-ea4b329cb31d',
    disciplineCode: 'CUR',
  },
  {
    $id: randomUUID(),
    date: '2021-03-13',
    event: '2-woman',
    type: MedalType.Bronze,
    athleteId: '474f51db-9685-43b1-bab1-7653eca34ac2',
    disciplineCode: 'BOB',
  },
  {
    $id: randomUUID(),
    date: '2021-08-22',
    event: "Women's Freeski Halfpipe",
    type: MedalType.Bronze,
    athleteId: '1d87e971-032e-44aa-806d-e5757ae4217b',
    disciplineCode: 'FRS',
  },
  {
    $id: randomUUID(),
    date: '2021-09-24',
    event: "Women's 12.5km Mass Start",
    type: MedalType.Gold,
    athleteId: '793ef372-f87b-47b7-8840-c837ed4f0edb',
    disciplineCode: 'BTH',
  },
]
