--[[
Parse module for Corona SDK v1.5
Copyright (c) 2013-14 develephant
MIT License - see https://bitbucket.org/develephant/mod_parse/src/e5856a1615b8ccc3a28661b4f89198435e487fa0/LICENSE
]]--
local json = require("json")
local url = require("socket.url")

local Parse = 
{
  appId = "ni9gpjglpS7C6uCwOuTAnVV0nySg4g7hxHLnRFlq",
  apiKey = "rn3sImdi93KlhtBXsQbNXC7mBV41OvveyljmXFmI",
  
  showStatus = false,
  
  endpoint = "https://api.parse.com/1/",
  
  --Session token
  sessionToken = nil,
  --Event Dispatcher
  dispatcher = display.newGroup(),
  --Requests
  requestQueue = {},
  
  --Parse type constants
  NIL = nil,
  ERROR = "ERROR",
  EXPIRED = 101,
  OBJECT = "classes",
  USER = "users",
  LOGIN = "login",
  ANALYTICS = "events",
  INSTALLATION = "installations",
  CLOUD = "functions",
  FILE = "files",
  PUSH = "push",

  --class constants
  USER_CLASS = "_User",

  --action constants
  POST = "POST",
  GET = "GET",
  PUT = "PUT",
  DELETE = "DELETE",
  
  --upload types
  TEXT = "text/plain",
  PNG = "image/png",
  JPG = "images/jpeg",
}

--------------------------------------------------------------------- 
-- Parse API OBJECT
---------------------------------------------------------------------  
function Parse:createObject( objClass, objDataTable, _callback )
  local uri = Parse:getEndpoint( Parse.OBJECT .. "/" .. objClass )
  return self:sendRequest( uri, objDataTable, Parse.OBJECT, Parse.POST, _callback )
end

function Parse:getObject( objClass, objId, _callback  )
  local uri = Parse:getEndpoint( Parse.OBJECT .. "/" .. objClass .. "/" .. objId )
  return self:sendRequest( uri, {}, Parse.OBJECT, Parse.GET, _callback )
end

function Parse:updateObject( objClass, objId, objDataTable, _callback )
  local uri = Parse:getEndpoint( Parse.OBJECT .. "/" .. objClass .. "/" .. objId )
  return self:sendRequest( uri, objDataTable, Parse.OBJECT, Parse.PUT, _callback )
end

function Parse:deleteObject( objClass, objId, _callback  )
  local uri = Parse:getEndpoint( Parse.OBJECT .. "/" .. objClass .. "/" .. objId )
  return self:sendRequest( uri, {}, Parse.OBJECT, Parse.DELETE, _callback )
end

--query based
function Parse:getObjects( objClass, queryTable, _callback  )
  queryTable = queryTable or {}
  local uri = Parse:getEndpoint( Parse.OBJECT .. "/" .. objClass )
  return self:sendQuery( uri, queryTable, Parse.OBJECT, _callback )
end

function Parse:linkObject( parseObjectType, parseObjectId, linkField, objTypeToLink, parseObjIdToLink, _callback )
  local linkField = linkField
  local fileDataTable = { [linkField] = { ["className"] = objTypeToLink, ["objectId"] = parseObjIdToLink, ["__type"] = "Pointer" } }
  if parseObjectType == Parse.USER then
    return self:updateUser( parseObjectId, fileDataTable, _callback )
  else
    return self:updateObject( parseObjectType, parseObjectId, fileDataTable, _callback )
  end
  
  return nil
end

function Parse:unlinkObject( parseObjectType, parseObjectId, linkField, _callback )
  local linkField = linkField
  local fileDataTable = { [linkField] = json.null }
  if parseObjectType == Parse.USER then
    return self:updateUser( parseObjectId, fileDataTable, _callback )
  else
    return self:updateObject( parseObjectType, parseObjectId, fileDataTable, _callback )
  end
  
  return nil
end

--------------------------------------------------------------------- 
-- Parse API RELATIONS
--------------------------------------------------------------------- 
function Parse:createRelation( objClass, objId, objField, objDataTable, _callback )
  
  local uri
  if objClass == Parse.USER then
    uri = Parse:getEndpoint( Parse.USER .. "/" .. objId )
  else
    uri = Parse:getEndpoint( Parse.OBJECT .. "/" .. objClass .. "/" .. objId ) 
  end

  local objects = {}
  for r=1, #objDataTable do
    table.insert( objects,
      { ["__type"] = "Pointer", ["className"] = objDataTable[r].className, ["objectId"] = objDataTable[r].objectId }
    )
  end
  
  local objField = objField
  local relationDataTable = {
    [ objField ] = { ["__op"] = "AddRelation", ["objects"] = objects }
  }

  return self:sendRequest( uri, relationDataTable, Parse.OBJECT, Parse.PUT, _callback )
end

function Parse:removeRelation( objClass, objId, objField, objDataTable, _callback )
  
  local uri
  if objClass == Parse.USER then
    uri = Parse:getEndpoint( Parse.USER .. "/" .. objId )
  else
    uri = Parse:getEndpoint( Parse.OBJECT .. "/" .. objClass .. "/" .. objId )
  end
  
  local objects = {}
  for r=1, #objDataTable do
    table.insert( objects,
      { ["__type"] = "Pointer", ["className"] = objDataTable[r].className, ["objectId"] = objDataTable[r].objectId }
    )
  end
  
  local objField = objField
  local relationDataTable = {
    [ objField ] = { ["__op"] = "RemoveRelation", ["objects"] = objects }
  }
  
  return self:sendRequest( uri, relationDataTable, Parse.OBJECT, Parse.PUT, _callback )
end
--------------------------------------------------------------------- 
-- Parse API FILE
---------------------------------------------------------------------  
function Parse:uploadFile( fileMetaTable, _callback )
  
  --filename, directory
  assert( fileMetaTable.filename, "A filename is required in the meta table")

  local fileName = fileMetaTable.filename
  local directory = fileMetaTable.baseDir or system.TemporaryDirectory
  
  --determine mime
  local contentType = self:getMimeType( fileName )
  
  local fileParams = self:newFileParams( contentType )

  local q = { 
    requestId = network.upload(
      self.endpoint .. self.FILE .. "/" .. fileName,
      self.POST,
      function(e) self:onResponse(e); end,
      fileParams,
      fileName,
      directory,
      contentType 
    ),
    requestType = self.FILE,
    _callback = _callback,
  }
  table.insert( self.requestQueue, q )
  
  return q.requestId
  
end

--V1.5 fix by https://bitbucket.org/neilhannah - Thanks!
function Parse:linkFile( parseObjectType, parseObjectId, linkField, parseFileUriToLink, parseFileUriToLinkUrl, _callback )
  local linkField = linkField
  local fileDataTable = { [linkField] = { ["name"] = parseFileUriToLink, ["url"] = parseFileUriToLinkUrl, ["__type"] = "File" } }
  if parseObjectType == Parse.USER then
    return self:updateUser( parseObjectId, fileDataTable, _callback )
  else
    return self:updateObject( parseObjectType, parseObjectId, fileDataTable, _callback )
  end
  
  return nil
end

function Parse:unlinkFile( parseObjectType, parseObjectId, linkField, _callback )
  local linkField = linkField
  local fileDataTable = { [linkField] = json.null }
  if parseObjectType == Parse.USER then
    return self:updateUser( parseObjectId, fileDataTable, _callback )
  else
    return self:updateObject( parseObjectType, parseObjectId, fileDataTable, _callback )
  end
  
  return nil
end

function Parse:deleteFile( parseFileName, parseMasterKey, _callback )
  assert( parseMasterKey, "Parse Master Key is required to delete a file.")
  local uri = Parse.endpoint .. Parse.FILE .. "/" .. parseFileName
  return self:sendRequest( uri, {}, Parse.FILE, Parse.DELETE, _callback, parseMasterKey )
end
--------------------------------------------------------------------- 
-- Parse API BATCH
--------------------------------------------------------------------- 
-- TODO

--------------------------------------------------------------------- 
-- Parse API USER
---------------------------------------------------------------------  
function Parse:createUser( objDataTable, _callback )
  local uri = Parse:getEndpoint( Parse.USER )
  return self:sendRequest( uri, objDataTable, Parse.USER, Parse.POST, _callback )
end

function Parse:createQuestion( objDataTable, _callback )
  local uri = Parse:getEndpoint( Parse.OBJECT )
  return self:sendRequest( uri, objDataTable, Parse.QUESTIONS, Parse.POST, _callback )
end

function Parse:getUser( objId, _callback  )
  local uri = Parse:getEndpoint( Parse.USER .. "/" .. objId )
  return self:sendRequest( uri, {}, Parse.USER, Parse.GET, _callback )
end

--query based
function Parse:getUsers( queryTable, _callback )
  queryTable = queryTable or {}
  local uri = Parse:getEndpoint( Parse.USER )
  return self:sendQuery( uri, queryTable, Parse.OBJECT, _callback )
end

function Parse:loginUser( objDataTable, _callback  )
  local uri = nil
  
  if objDataTable.authData == nil then
    uri = Parse:getEndpoint( Parse.LOGIN )
    return self:sendQuery( uri, objDataTable, Parse.LOGIN, _callback )
  else --facebook/twitter/UUID login
    uri = Parse:getEndpoint( Parse.USER )
    return self:sendRequest( uri, objDataTable, Parse.USER, Parse.POST, _callback )   
  end
  
  return nil
end

--MUST BE LOGGED IN FIRST WITH SESSION TOKEN
function Parse:updateUser( objId, objDataTable, _callback  )
  
  assert( self.sessionToken, "User must be logged in first, sessionToken cannot be nil.")
  
  local uri = Parse:getEndpoint( Parse.USER .. "/" .. objId )
  return self:sendRequest( uri, objDataTable, Parse.USER, Parse.PUT, _callback )
end
--MUST BE LOGGED IN FIRST WITH SESSION TOKEN
function Parse:getMe( _callback )
  
  assert( self.sessionToken, "User must be logged in first, sessionToken cannot be nil.")
  
  local uri = Parse:getEndpoint( Parse.USER .. "/me" )
  return self:sendRequest( uri, {}, Parse.USER, Parse.GET, _callback )
end
--MUST BE LOGGED IN FIRST WITH SESSION TOKEN
function Parse:deleteUser( objId, _callback  )
  
  assert( self.sessionToken, "User must be logged in first, sessionToken cannot be nil.")
  
  local uri = Parse:getEndpoint( Parse.USER .. "/" .. objId )
  return self:sendRequest( uri, {}, Parse.USER, Parse.DELETE, _callback )
end

function Parse:requestPassword( email, _callback  )
  local uri = Parse:getEndpoint( "requestPasswordReset" )
  return self:sendRequest( uri, { ["email"] = email }, Parse.USER, Parse.POST, _callback )  
end

--------------------------------------------------------------------- 
-- Parse API ANALYTICS
---------------------------------------------------------------------  
function Parse:appOpened( _callback )
  local uri = Parse:getEndpoint( Parse.ANALYTICS .. "/AppOpened" )
  local requestParams = {}
  return self:sendRequest( uri, { at = "" }, Parse.ANALYTICS, Parse.POST, _callback )  
end

function Parse:logEvent( eventType, dimensionsTable, _callback )
  dimensionsTable = dimensionsTable or {}
  
  local uri = Parse:getEndpoint( Parse.ANALYTICS .. "/" .. eventType )
  local requestParams = {
    ["dimensions"] = dimensionsTable
  }
  return self:sendRequest( uri, requestParams, Parse.ANALYTICS, Parse.POST, _callback )
end

--------------------------------------------------------------------- 
-- Parse API PUSH
---------------------------------------------------------------------
-- TODO 

--------------------------------------------------------------------- 
-- Parse API INSTALLATIONS
---------------------------------------------------------------------
function Parse:createInstallation( objDataTable, _callback )
  local uri = Parse:getEndpoint( Parse.INSTALLATION )
  return self:sendRequest( uri, objDataTable, Parse.INSTALLATION, Parse.POST, _callback ) --returns requestId
end
 
function Parse:updateInstallation( objId, objDataTable, _callback )
  local uri = Parse:getEndpoint( Parse.INSTALLATION .. "/" .. objId )
  return self:sendRequest( uri, objDataTable, Parse.INSTALLATION, Parse.PUT, _callback ) --returns requestId
end
 
function Parse:getInstallation( objId, _callback  )
  local uri = Parse:getEndpoint( Parse.INSTALLATION .. "/" .. objId )
  return self:sendRequest( uri, {}, Parse.INSTALLATION, Parse.GET, _callback ) --returns requestId
end
--------------------------------------------------------------------- 
-- Parse API CLOUD FUNCTIONS
---------------------------------------------------------------------
function Parse:run( functionName, functionParams, _callback )
  functionParams = functionParams or {[""] = ""}
  
  local uri = Parse:getEndpoint( Parse.CLOUD .. "/" .. functionName )
  return self:sendRequest( uri, functionParams, Parse.CLOUD, Parse.POST, _callback ) --returns requestId
end

---------------------------------------------------------------------
-- Parse Module Internals
---------------------------------------------------------------------

-- REQUESTS --
function Parse:buildRequestParams( withDataTable, masterKey )
  local postData = json.encode( withDataTable )
  return self:newRequestParams( postData, masterKey ) --for use in a network request
end

function Parse:sendRequest( uri, requestParamsTbl, requestType, action, _callback, masterKey )
  local requestParams = self:buildRequestParams( requestParamsTbl, masterKey )
  
  requestType = requestType or Parse.NIL
  action = action or Parse.POST

  local q = { 
    requestId = network.request( uri, action, function(e) Parse:onResponse(e); end, requestParams ),
    requestType = requestType,
    _callback = _callback,
  }
  table.insert( self.requestQueue, q )
  
  return q.requestId
end

-- QUERIES --
function Parse:buildQueryParams( withQueryTable )
  local uri = ""
  for key, v in pairs( withQueryTable ) do
    if uri ~= "" then
      uri = uri .. "&"
    end
    
    local value = v
    if key == "where" then
      value = url.escape( json.encode( v ) )
    end
    
    uri = uri .. tostring( key ) .. "=" .. value
    
  end
  return self:newRequestParams( uri ) --for use in a network request
end

function Parse:sendQuery( uri, queryParamsTbl, requestType, _callback )
  local requestParams = self:buildQueryParams( queryParamsTbl )

  requestType = requestType or Parse.NIL
  --action = action or Parse.GET
  
  local queryUri = uri .. "?" .. requestParams.body

  local q = { requestId = network.request( queryUri, Parse.GET, function(e) Parse:onResponse(e); end, requestParams ),
    requestType = requestType,
    _callback = _callback,
  }
  table.insert( self.requestQueue, q )
  
  return q.requestId
end

-- FILES  --
function Parse:buildFileParams( withDataTable )
  local postData = json.encode( withDataTable )
  return self:newRequestParams( postData ) --for use in a network request
end

function Parse:sendFile( uri, requestParamsTbl, requestType, action )
  local requestParams = self:buildRequestParams( requestParamsTbl )
  
  requestType = requestType or Parse.NIL
  action = action or Parse.POST

  local q = { requestId = network.request( uri, action, function(e) Parse:onResponse(e); end, requestParams ), requestType = requestType }
  table.insert( self.requestQueue, q )
  
  return q.requestId
end

-- SESSION --
function Parse:setSessionToken( sessionId )
  self.sessionToken = sessionId
  return self.sessionToken
end

function Parse:getSessionToken()
  return self.sessionToken
end

function Parse:clearSessionToken()
  self.sessionToken = nil
end

-- RESPONSE --
function Parse:onResponse( event )
  if event.phase == "ended" then
  
    local status = event.status
    local requestId = event.requestId
    
    local response, decodedResponse
    if status ~= -1 then
      response = event.response
      decodedResponse = json.decode(response)
      
    if self.showStatus then
      local msg = "Net Status: " .. status .. "\n"
      
      if decodedResponse.code then
        msg = msg .. "Parse Code: " .. decodedResponse.code .. "\n"
        if decodedResponse.error then
          msg = msg .. "Error: " .. decodedResponse.error
        end
      else
        msg = "Parse action was successful."
      end
      
      native.showAlert( "Parsed!", msg , { "OK" } )

      print( "Parsed!\n" .. msg )
    end
      
    end
    
    --find request
    local requestType = Parse.NIL
    local _callback = nil
    for r=1, #self.requestQueue do
      local request = self.requestQueue[ r ]
      if request.requestId == requestId then
        requestType = request.requestType
        _callback = request._callback
        table.remove( self.requestQueue, r )
        break
      end
    end

    --broadcast response
    local e = nil
    if status == -1 then --timed out
      e = {
        name = "parseRequest",
        requestId = requestId,
        requestType = requestType,
        response = nil,
        code = -1,
        error = "The request timed out.",
      }
    elseif status >= 200 and status < 400 then
      e = {
        name = "parseRequest",
        requestId = requestId,
        requestType = requestType,
        response = decodedResponse,
        code = nil,
        error = nil,
      }

      --check for multiple results, add helper property
      if decodedResponse and decodedResponse.results ~= nil then
        e.results = decodedResponse.results
      end

      --Got session token, store it.
      if decodedResponse.sessionToken then
        self.sessionToken = decodedResponse.sessionToken
      end
    elseif status >= 400 then  -- error
      e = {
        name = "parseRequest",
        requestId = requestId,
        requestType = self.ERROR,
        response = nil,
        code = decodedResponse.code,
        error = decodedResponse.error, 
      }
    end
    
    --broadcast it
    if e ~= nil then
      if _callback then
        _callback( e )
      else --use global event
        self.dispatcher:dispatchEvent( e )
      end
    end
    
  end
end

function Parse:newRequestParams( bodyData, masterKey )
  --set up headers
  local headers = {}
  headers["X-Parse-Application-Id"] = self.appId
  headers["X-Parse-REST-API-Key"] = self.apiKey
  
  --session?
  if self.sessionToken then
    headers["X-Parse-Session-Token"] = self.sessionToken
  end
  
  --masterkey?
  if masterKey then
    headers["X-Parse-Master-Key"] = masterKey
  end
  
  headers["Content-Type"] = "application/json"

  --populate parameters for the network call
  local requestParams = {}
  requestParams.headers = headers
  requestParams.body = bodyData

  return requestParams
end

-- FILE PARAMS
function Parse:newFileParams( contentType )
  --set up headers
  local headers = {}
  headers["X-Parse-Application-Id"] = self.appId
  headers["X-Parse-REST-API-Key"] = self.apiKey
  
  local requestParams = {}

  headers["Content-Type"] = contentType

  --populate parameters for the network call
  requestParams = {}
  requestParams.headers = headers
  requestParams.bodyType = "binary"

  return requestParams
end

function Parse:getEndpoint( typeConstant )
  return self.endpoint .. typeConstant
end

function Parse:cancelRequest( requestId )
  network.cancel( requestId )
end

function Parse:getMimeType( filePath )

  local path = string.lower( filePath )
  local mime = nil

  if string.find( path, ".txt" ) ~= nil then
    mime = self.TEXT
  elseif string.find( path, ".jpg" ) ~= nil then
    mime = self.JPG
  elseif string.find( path, ".jpeg" ) ~= nil then
    mime = self.JPG
  elseif string.find( path, ".png" ) ~= nil then
    mime = self.PNG
  end
  
  return mime
end

function Parse:timestampToISODate( unixTimestamp )
  --2013-12-03T19:01:25Z"
  unixTimestamp = unixTimestamp or os.time()
  return os.date( "!%Y-%m-%dT%H:%M:%SZ", unixTimestamp )
end

function Parse:init( o )
  self.appId = o.appId
  self.apiKey = o.apiKey
end

return Parse
