import { Query } from 'node-appwrite'
import { collections, database } from '../appwrite'
import { Discipline } from '../models/types'

export const disciplineService = {
  async getDisciplines(): Promise<Array<Discipline>> {
    const response = await database.listDocuments(collections.disciplines)

    return response.documents.map((doc) => doc as any as Discipline)
  },

  async getDisciplinByCode(code: string): Promise<Discipline> {
    const codeQuery = [Query.equal('code', code)]

    const response = await database.listDocuments(collections.disciplines, codeQuery, 1)

    return response.documents[0] as any as Discipline
  },
}
