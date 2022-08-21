# AstraTween
AstraTween is a basic client tweening and model tweening module for Roblox to improve visual quality and smoothness. It takes the responsiblity of tweening from the server to the client, allowing for much smoother animations whilst maintaining replication.

AstraTween is pretty limited, as it currently does not have support for pausing/cancelling tweens once they begin. Any ideas for how to implement new features would be greatly appreciated.

# Setup
To set up AstraTween, create a ModuleScript and a LocalScript. The ModuleScript (which should be named "AstraTween") should be a descendant of `ReplicatedStorage`.

Secondly, take the LocalScript (name it "AstraTweenLocal") and place it as a descendant of `StarterPlayerScripts`. 

Lastly, paste the code from `/src/` into each of the scripts. Make sure to set the `rootPath` variable on line 1 of the LocalScript to the parent of the module. From there, use the following documentation to run client tweens from any other Server-sided script. **Do not attempt to use this locally. Using TweenService is functionally identical to using AstraTween client-sided, and is much less complex.**

# Documentation

## AstraTween:TweenModel(model, time, style, dir, goalPosition)

Tweens a model using it's `PrimaryPart` as a pivot.

| Argument     | Class         |
| ------------- | ------------- |
| `model`         | `Model` (PrimaryPart must be set!) |
| `time`         | `number` |
| `style`         | `Enum.EasingStyle` |
| `dir`         | `Enum.EasingDirection` |
| `goalPosition` | `CFrame / BasePart / Vector3` |



## AstraTween:TweenInstance(target, time, style, dir, goalTable)

Tweens an instance. Functionally identical to `TweenService:Create()` but with fewer arguments. Use `TweenInstanceFull` to access lesser used properties.

| Argument     | Class         |
| ------------- | ------------- |
| `target`         | `BasePart / MeshPart` (`UnionOperation` is untested. Use at your own discretion.) |
| `time`         | `number` |
| `style`         | `Enum.EasingStyle` |
| `dir`         | `Enum.EasingDirection` |
| `goalTable` | `{Property = Value, ...}` (Identical to the one used in `TweenService:Create()`.) |



## AstraTween:TweenInstanceFull(target, time, style, dir, repCount, reverses, delayTime, goalTable)

Tweens an instance. Functionally identical to `TweenService:Create()`.

| Argument     | Class         |
| ------------- | ------------- |
| `target`         | `BasePart / MeshPart` (`UnionOperation` is untested. Use at your own discretion.) |
| `time`         | `number` |
| `style`         | `Enum.EasingStyle` |
| `dir`         | `Enum.EasingDirection` |
| `repCount`         | `number` (number of repeats, set to -1 for infinite repeats.) |
| `reverses`         | `bool` (does the tween reverse on itself after completing?) |
| `delayTime`         | `number` (amount of time in seconds between repeats.) |
| `goalTable` | `{Property = Value, ...}` (Identical to the one used in `TweenService:Create()`.) |
