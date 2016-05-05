markDuplicate = ->
  $('body').on 'click', '.mark-dup', ->
    link_object = $(this)
    record_id = link_object.attr('data-id')
    url = "/duplicate_hotel_records/"+ record_id + "/change_duplicate_status"
    $.ajax
      url: url
      type: 'PUT'
      success: (res)->
        if res.duplicate_status
          link_object.parent().html('Duplicate')

unMarkDuplicate = ->
  $('body').on 'click', '.unmark-dup', ->
    link_object = $(this)
    record_id = link_object.attr('data-id')
    url = "/duplicate_hotel_records/"+ record_id + "/change_duplicate_status"
    $.ajax
      url: url
      type: 'PUT'
      success: (res)->
        unless res.duplicate_status
          link_object.parent().parent().remove()


searchHotels = ->
  hotels = $('#hotel_ids').val()
  if hotels
    hotel_ids = hotels.split(' ')
    $.each hotel_ids, (i, val) ->
      this_object = $('#source_hotel_' + val)
      this_object.autocomplete
        select: (event, ui)->
          source = ui.item.source
          if source == 'yatra'
            data = { 'duplicate_hotel_record': { 'cleartrip_hotel_id': ui.item.duplicate_hotel_id, 'yatra_hotel_id': ui.item.id }, 'source_hotel_id': ui.item.duplicate_hotel_id, 'source': 'yatra' }
          else
            data = { 'duplicate_hotel_record': { 'cleartrip_hotel_id': ui.item.id, 'yatra_hotel_id': ui.item.duplicate_hotel_id }, 'source_hotel_id': ui.item.duplicate_hotel_id, 'source': 'cleartrip' }

          $.ajax
            url: '/duplicate_hotel_records'
            type: 'POST'
            data: data
            success: (res)->

        minLength: 2
        delay: 500
        source: this_object.data('autocomplete-source')

$(document).ready ->
  markDuplicate()
  searchHotels()
  unMarkDuplicate()

