app.service 'preprocess', () ->
  this.firstPass = (json,records,time_limits) ->
    console.log "I'm in the firstpass"
    # -makes the first pass over the data
    # -converts time strings to moment objects (see moment.js documentation)
    # -aggregates the unique event types into the 'event_types' array
    # -aggregates events into records
    # @param json: raw data - an array of objects of form
    #       {'event':'<event type here>'
    #         'ts':'<start of event>'
    #         'te':'<end of event>'
    #         'id':'<id of the record where the event occured (game/patient/etc.)>'
    #       }
    # @param records: an empty array to be populated with records
    console.log("preprocess reached")
    recordHash = {}
    if json.events
      event_types = {}
      for p in json.events
        #add new category if not present
        event_types[p.event] = true if p.event not in event_types
        #convert time string to moment
        if p.ts
          p.ts = moment(p.ts)
          if p.ts.isBefore(time_limits.first_time) then time_limits.first_time = p.ts
          if p.ts.isAfter(time_limits.last_time) then time_limits.last_time = p.ts
          if p.te
            p.te = moment(p.te)
         #aggregate records
        if p.id.toString() in Object.keys(recordHash)
          record = recordHash[p.id]
          record.push(p)
        else
          record = [p]
          recordHash[p.id] = record
      for recordId in  Object.keys(recordHash)
        record = recordHash[recordId]
        #sort the records based on time
        record.sort((a,b)->
          if(a.ts > b.ts)
            1
          else if(b.ts > a.ts)
            -1
          else
            0
          )
        records.push(recordHash[recordId])
      event_types = Object.keys(event_types)
      event_types.sort()
