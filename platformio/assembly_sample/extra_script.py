Import("env")
env.Append(
  LINKFLAGS=[
      "-Wa,-march=rv32imac",
      "-march=rv32imac"
  ]
)