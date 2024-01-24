export type Athlete = {
  $id: string
  name: string
  gender: Gender
  birthdate: string
  countryCode: string
}

export type Medal = {
  $id: string
  date: string
  event: string
  type: MedalType
  athleteId: string
  disciplineCode: string
}

export type Country = {
  $id: string
  name: string
  code: string
}

export type Discipline = {
  $id: string
  name: string
  code: string
}

export enum MedalType {
  Gold = 'Gold',
  Silver = 'Silver',
  Bronze = 'Bronze',
}

export enum Gender {
  Male = 'Male',
  Female = 'Female',
}
