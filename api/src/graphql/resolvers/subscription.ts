import { PubSub } from 'graphql-subscriptions'
import { ApiAthlete, ApiMedal } from '../../models/api'
import { Athlete, Medal } from '../../models/types'
import { athleteService } from '../../services/athleteService'
import { medalService } from '../../services/medalService'
import { resolveAthlete, resolveMedal } from './common'

export const subscription = {
  athleteRegistered: {
    subscribe: () => SubscriptionBroker.instance.subscribeAthleteRegistered(),
  },
  medalAwarded: {
    subscribe: () => SubscriptionBroker.instance.subscribeMedalAwarded(),
  },
}

class SubscriptionBroker {
  static instance = new SubscriptionBroker()

  private pubsub = new PubSub()
  private channels = {
    athleteRegistered: 'athleteRegistered',
    medalAwarded: 'medalAwarded',
  }

  subscribeAthleteRegistered(): AsyncIterator<ApiAthlete> {
    return this.pubsub.asyncIterator(this.channels.athleteRegistered)
  }

  subscribeMedalAwarded(): AsyncIterator<ApiMedal> {
    return this.pubsub.asyncIterator(this.channels.medalAwarded)
  }

  private constructor() {
    medalService.medalAwardedSubject.subscribe((medal) => this.onMedalAwarded(medal))
    athleteService.athleteRegisteredSubject.subscribe((athlete) =>
      this.onAthleteRegistered(athlete),
    )
  }

  private onAthleteRegistered(athlete: Athlete) {
    const channel = this.channels.athleteRegistered
    const data = {
      athleteRegistered: resolveAthlete(athlete),
    }

    this.pubsub.publish(channel, data)
  }

  private onMedalAwarded(medal: Medal) {
    const channel = this.channels.medalAwarded
    const data = {
      medalAwarded: resolveMedal(medal),
    }

    this.pubsub.publish(channel, data)
  }
}
