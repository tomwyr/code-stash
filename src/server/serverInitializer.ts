import { execute, GraphQLSchema, subscribe } from 'graphql'
import { WebSocketServer } from 'ws'
import { SubscriptionServer } from 'subscriptions-transport-ws'
import { useServer } from 'graphql-ws/lib/use/ws'

export class apolloServerInitializers {
  static graphqlWs: ServerInitializer = ({ schema, wsServer }) => {
    const serverCleanup = useServer({ schema }, wsServer)

    return serverCleanup.dispose
  }

  static subscriptionsTransportWs: ServerInitializer = ({ schema, wsServer }) => {
    const serverOptions = { schema, execute, subscribe }
    const subscriptionServer = SubscriptionServer.create(serverOptions, wsServer)

    return subscriptionServer.close
  }
}

export type ServerInitializer = (options: ServerInitializerOptions) => ServerDisposer
export type ServerInitializerOptions = {
  schema: GraphQLSchema
  wsServer: WebSocketServer
}
export type ServerDisposer = () => void | Promise<any>
