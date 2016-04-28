markDuplicate = ->
  $('.mark-dup').on 'click', ->
    link_object = $(this)
    record_id = link_object.attr('data-id')
    url = "/duplicate_hotel_records/"+ record_id + "/change_duplicate_status"
    $.ajax
      url: url
      type: 'PUT'
      success: (res)->
        if res.duplicate_status
          link_object.parent().html('Marked')

$(document).ready ->
  markDuplicate()

