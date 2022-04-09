import { Client, Database } from 'node-appwrite'

const endpoint = 'http://localhost/v1'
const project = '622fd1908e98b54c9988'
const key =
  'ce032025c008c8761f4e05778ee740643caa3ab2a08b4cb058bcf276a403ca3768c591da8e21f7cc46a532b5c3b4ed4fd7bc4d3544643ed7e767c0adce6ab292306def1c942ed80215e62f338e131b5ba7bc655a57a7508be75b8b165a61860b6d311c18fa208e6616b124b639bb2aee66c8de16bcc5f6ba2289e9d289bcdc82'

const client = new Client().setEndpoint(endpoint).setProject(project).setKey(key)

export const database = new Database(client)

export const uniqueId = 'unique()'

export const collections = {
  medals: '62362d7f54afdb342bed',
  athletes: '62362dc0b639f88fe592',
  countries: '62362dd94087879bdef8',
  disciplines: '62362de959fb9afcfa27',
}
