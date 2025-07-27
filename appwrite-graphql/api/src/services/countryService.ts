import { Query } from 'node-appwrite'
import { collections, database } from '../appwrite'
import { Country } from '../models/types'

export const countryService = {
  async getCountries(): Promise<Array<Country>> {
    const response = await database.listDocuments(collections.countries)

    return response.documents.map((doc) => doc as any as Country)
  },

  async getCountryByCode(code: string): Promise<Country> {
    const codeQuery = [Query.equal('code', code)]

    const response = await database.listDocuments(collections.countries, codeQuery, 1)

    return response.documents[0] as any as Country
  },
}
