import { collections, database } from '../appwrite'

export async function clearAllCollections() {
  await clearCollection(collections.countries)
  await clearCollection(collections.disciplines)
  await clearCollection(collections.athletes)
  await clearCollection(collections.medals)
}

export async function clearCollection(collectionId: string) {
  while (true) {
    const docList = await database.listDocuments(collectionId, null, 100)

    if (docList.documents.length == 0) break

    for (const doc of docList.documents) {
      await database.deleteDocument(collectionId, doc.$id)
    }
  }
}
