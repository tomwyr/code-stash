import { AthleteInput, MedalInput } from '../../models/inputs'
import { athleteService } from '../../services/athleteService'
import { medalService } from '../../services/medalService'
import { resolveAthlete, resolveMedal } from './common'

export const mutation = {
  registerAthlete: async (_parent, args) => {
    const input = args.input as AthleteInput

    const athlete = await athleteService.createAthlete(input)

    return resolveAthlete(athlete)
  },

  awardMedal: async (_parent, args) => {
    const input = args.input as MedalInput

    const medal = await medalService.createMedal(input)

    return resolveMedal(medal)
  },
}
