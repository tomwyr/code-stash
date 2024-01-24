import express from 'express'
import { createServer } from 'http'
import { WebSocketServer } from 'ws'
import { createApolloServer } from './createApolloServer'
import { apolloServerInitializers } from './serverInitializer'

export async function startServer() {
  const app = express()

  const httpServer = createServer(app)
  const wsServer = new WebSocketServer({
    server: httpServer,
    path: '/graphql',
  })

  const serverInitializer = apolloServerInitializers.subscriptionsTransportWs
  const server = createApolloServer({ httpServer, wsServer, serverInitializer })

  await server.start()
  server.applyMiddleware({ app })

  httpServer.listen({ port: 4000 }, () =>
    console.log(`🚀 Server ready at http://localhost:4000${server.graphqlPath}`),
  )
}
