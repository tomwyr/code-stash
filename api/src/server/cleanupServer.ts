import { PluginDefinition } from 'apollo-server-core'

export function cleanupServer(options: CleanupServerOptions): PluginDefinition {
  return {
    async serverWillStart() {
      return {
        async drainServer() {
          await options.serverCleanup()
        },
      }
    },
  }
}

export interface CleanupServerOptions {
  serverCleanup: () => void | Promise<any>
}
