WhitelistManager = require 'meshblu-core-manager-whitelist'
http             = require 'http'

class CheckWhitelistDiscoverView
  constructor: ({datastore, @whitelistManager, uuidAliasResolver}) ->
    @whitelistManager ?= new WhitelistManager {datastore, uuidAliasResolver}

  do: (job, callback) =>
    {fromUuid, toUuid, responseId, auth} = job.metadata
    fromUuid ?= auth.uuid
    emitter = fromUuid
    subscriber = toUuid
    @whitelistManager.checkDiscoverView {emitter, subscriber}, (error, verified) =>
      return @sendResponse responseId, 500, callback if error?
      return @sendResponse responseId, 403, callback unless verified
      @sendResponse responseId, 204, callback

  sendResponse: (responseId, code, callback) =>
    callback null,
      metadata:
        responseId: responseId
        code: code
        status: http.STATUS_CODES[code]

module.exports = CheckWhitelistDiscoverView
