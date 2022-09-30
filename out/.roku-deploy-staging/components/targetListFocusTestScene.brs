sub init()
  m.tList = m.top.findNode("tList")
  m.video = m.top.findNode("exampleVideo")
  m.groupp = m.top.FindNode("groupp")
  m.myInterp2 = m.top.FindNode("myInterp2")
  m.timerToHighDisplay = m.top.FindNode("timerToHighDisplay")
  m.timerToVideoDisplay = m.top.FindNode("timerToVideoDisplay")

  unfocusedTargetSet = createObject("roSGNode", "TargetSet")
  m.focusedTargetSetSmall = createObject("roSGNode", "TargetSet")

  m.tList.duration = 1
  m.tList.itemComponentName = "SimpleItemComponent"
  m.tList.focusedTargetSet = [ m.focusedTargetSetSmall ]

  m.tList.showTargetRects = false 

  m.focusedTargetSetSmall.targetRects = [
    { x:0, y:-140, width:230, height:450 },
    { x:250, y:-140, width:230, height:450 },
    { x:500, y:-140, width:230, height:450 },
    { x:750,  y:-140, width:230, height:450 },
    { x:1000,  y:-140,  width:230, height:450 },
    { x:1250,  y:-140,  width:230, height:450 },
    { x:1500,  y:-140,   width:230, height:450 }
  ]
  m.tList.targetSet = m.focusedTargetSetSmall

  m.tList.unfocusedTargetSet = unfocusedtargetSet
  unfocusedTargetSet.targetRects = [
    { x:0, y:-140, width:230, height:450 },
    { x:250, y:-140, width:230, height:450 },
    { x:500, y:-140, width:230, height:450 },
    { x:750,  y:-140, width:230, height:450 },
    { x:1000,  y:-140,  width:230, height:450 },
    { x:1250,  y:-140,  width:230, height:450 },
    { x:1500,  y:-140,   width:230, height:450 }
  ]
  m.amountOfItems = 14

  dataModel = setUpDataModel()
  m.tList.content = dataModel

  m.top.observeField("focusedChild", "onFocus")

  m.tList.observeField("itemFocused", "itemFocusedChanged")
  m.tList.observeField("itemUnfocused", "itemUnfocusedChanged")
  m.tList.observeField("itemSelected", "itemSelectedChanged")

  m.focusedTargetSmallDisplay = createObject("roSGNode", "TargetSet")
  
  m.focusedTargetSmallDisplay.targetRects = [
    { x:0, y:-140, width:230, height:450 },
    { x:250, y:-140, width:230, height:450 },
    { x:500,  y:-140, width:230, height:450 },
    { x:750,  y:-140,  width:230, height:450 },
    { x:1000,  y:-140,  width:230, height:450 },
    { x:1250,  y:-140,   width:230, height:450 },
    { x:1500,  y:-140,   width:230, height:450 }
  ]

  m.focusedTargetHighDisplay = createObject("roSGNode", "TargetSet")

  m.focusedTargetHighDisplay.targetRects = [
    { x:0, y:-140, width:230, height:450 },
    { x:250, y:-140, width:870, height:450 },
    { x:1140, y:-140, width:230, height:450 },
    { x:1390,  y:-140,   width:230, height:450 },
    { x:1640,  y:-140,  width:230, height:450 },
    { x:1890,  y:-140,  width:230, height:450 },
    { x:2140,  y:-140,  width:230, height:450 }
  ]

  m.IsInHighDisplay = false

  m.timerToHighDisplay.observeField("fire", "onHighDisplay")
  m.timerToVideoDisplay.observeField("fire", "videoDisplay")

  m.tList.setFocus(true)


end sub

function setUpDataModel()
    contentRoot = createObject("roSGNode", "ContentNode")
      for i = 0 to m.amountOfItems
        child = createObject("roSGNode", "dataTemplateItem")
        child.title = "Item " + i.tostr()

        contentItem = {
          url: "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8"
        }
        child.contentItem = contentItem
        if (i mod 2 = 0)
          child.poster = "pkg:/images/vikings.png"
        else 
          child.poster = "pkg:/images/squad.png"
        end if
        child.providerLogo = "pkg:/images/vikings16x9.png"

        contentRoot.appendChild(child)

    end for
    return contentRoot
end function

sub onFocus()
  if (m.top.hasFocus())
    m.tList.setFocus(true)
  end if
end sub

sub onHighDisplay()

  m.IsInHighDisplay = true
  m.tList.duration = 0.5
  m.tList.animateToTargetSet = m.focusedTargetHighDisplay

  m.timerToVideoDisplay.control = "START"

end sub

sub onSmallDisplay()
  m.video.visible = false
  m.video.control = "STOP"

  m.IsInHighDisplay = false
  m.tList.targetSet = m.focusedTargetSetSmall
end sub

sub itemFocusedChanged()
  m.tList.duration = 1
  m.timerToHighDisplay.control = "START"
end sub

sub itemUnfocusedChanged()
  m.timerToHighDisplay.control = "STOP"
  
  if (m.IsInHighDisplay = true)
    onSmallDisplay()
  end if
end sub

sub itemSelectedChanged()
  contentItemSelected = m.tList.content.getChild(m.tList.itemSelected)
end sub

sub videoDisplay()

  focusedItem = m.tList.content.getChild(m.tList.itemFocused)

  videocontent = createObject("RoSGNode", "ContentNode")
  videocontent.url = focusedItem.contentItem.url
  videocontent.title = focusedItem.title
  videocontent.streamformat = "hls"

  m.video.content = videocontent
  m.video.visible = true
  m.video.observeField("state", "OnVideoPlayerStateChange")
  m.video.control = "PLAY"
end sub

sub destroyPlayer()
  m.video.visible = false
  m.video.control = "stop"
  m.video.unobserveField("state")
  onSmallDisplay() ' Restart size of carousel
end sub

sub OnVideoPlayerStateChange()
  if (m.video.state = "finished")
      destroyPlayer()
  end if
end sub

