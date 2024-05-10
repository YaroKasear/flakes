const { speaker } = await Service.import("audio")

const slider = Widget.Slider({
    value: speaker.bind("volume"),
    onChange: ({ value }) => speaker.volume = value,
})

const Bar = () => Widget.Window({
  name: 'bar',
  anchor: ['top', 'left', 'right'],
  // child: Widget.Label({ label: date.bind() })
  child: slider
})

App.config({
  windows: [
    Bar(0)
  ],
})