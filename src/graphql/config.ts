import { mutation } from './resolvers/mutation'
import { query } from './resolvers/query'
import { subscription } from './resolvers/subscription'
import { typeDefs } from './typeDefs'

export const gqlConfig = {
  typeDefs: typeDefs,
  resolvers: {
    Query: query,
    Mutation: mutation,
    Subscription: subscription,
  },
}
