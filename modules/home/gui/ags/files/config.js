const { speaker } = await Service.import("audio")

const slider = Widget.Slider({
    value: speaker.bind("volume"),
    onChange: ({ value }) => speaker.volume = value,
})

const MyButton = () => Widget.Button()
    .on("clicked", self => {
        print(self, "is clicked")
    })

const Bar = () => Widget.Window({
  name: 'bar',
  anchor: ['top', 'left', 'right'],
  // child: Widget.Label({ label: date.bind() })
  child: MyButton
})

App.config({
  windows: [
    Bar(0)
  ],
  style: './style.css',
})