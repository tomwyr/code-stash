import { athleteService } from '../../services/athleteService'
import { countryService } from '../../services/countryService'
import { disciplineService } from '../../services/disciplineService'
import { medalService } from '../../services/medalService'
import { resolveAthlete, resolveCountry, resolveDiscipline, resolveMedal } from './common'

export const query = {
  athletes: async () => {
    const athletes = await athleteService.getAthletes()

    return athletes.map(resolveAthlete)
  },

  medals: async () => {
    const medals = await medalService.getMedals()

    return medals.map(resolveMedal)
  },

  countries: async () => {
    const countries = await countryService.getCountries()

    return countries.map(resolveCountry)
  },

  disciplines: async () => {
    const disciplines = await disciplineService.getDisciplines()

    return disciplines.map(resolveDiscipline)
  },
}
