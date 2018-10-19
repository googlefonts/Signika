# Making a "proper" GRAD Axis

As the previous doc says, a Grade axis should keep widths and prevent reflow. According to Mozilla Dev Network:

> The term 'grade' refers to the relative weight or density of the typeface design, but differs from traditional 'weight' in that the physical space the text occupies does not change, so changing the text grade doesn't change the overall layout of the text or elements around it.

— [Grade, MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Fonts/Variable_Fonts_Guide#Grade)

Signika and Signika Negative have a problem: they don't currently share text width, even though they should. This prevents grade from being used in a truly useful way on the web, where the primary function is likely to be making light/dark UI changes a possibility.

## Goals

1. Make a variable Grade axis happen _without_ reflow, starting by keeping the same weight relationships as the status-quo files (and possibly experiment with adjusting this).
2. Ideally, make the Grade axis happen with just _one_ additional master, to keep font weight down. This may be doable, because the point deltas for grade are so small.

## Approach

1. Taking the `Negative Light` instance, which had a wght value of `-15`, and converting it to a master

![Light Grade Master](assets/light-GRAD.png)
![Light Master](assets/light.png)

2. Using [a glyphs script](https://github.com/thundernixon/Signika/blob/6a36f0dd32c0db964460ab4f4500dcff0c55e24d/scripts/match-metrics.py) to copy glyph metrics from the `Light` master to the `Negative Light` master, to hopefully make point deltas only adjust grade, not overall glyph width, etc

![Grade Test](assets/signika-grade.gif)

3. Generating a VF and testing the result on bold weights

## Generating the variable font with both axes

![image-20181019135747417](/Users/stephennixon/Library/Application Support/typora-user-images/image-20181019135747417.png)	

At first, the VF that is generating is not including the Grade axis. To fix this, I'm trying a number of things:

1.  Adding a custom parameter in the Font Info

   ![image-20181019135811568](/Users/stephennixon/Library/Application Support/typora-user-images/image-20181019135811568.png)

2. Setting masters as:

| Master     | Weight | Grade |
| ---------- | ------ | ----- |
| Light-GRAD | 0      | 0     |
| Light      | 0      | 100   |
| Bold       | 1000   | 100   |
| Black      | 1350   | 100   |

3. Setting all instances to have Grade value of either `0` or `100`, depending on their normal/negative name



Strangely, so far this is leading FontMake to export a designspace with `GRAD` registered as:

```xml
<axis default="100" maximum="100" minimum="100" name="Grade" tag="GRAD" />
```



4. I have edited the `.designspace` file to 

```xml
<axes>
        <axis default="300" maximum="900" minimum="300" name="Weight" tag="wght">
            <map input="300" output="0" />
            <map input="400" output="291" />
            <map input="600" output="577" />
            <map input="700" output="843" />
            <map input="900" output="1350" />
        </axis>
        <axis default="100" maximum="100" minimum="0" name="Grade" tag="GRAD" />
    </axes>
```

Changing:

- `wght default` to `300`
- adding `input="900"` to AVAR map
- setting `GRAD` min to `0`

5. I will temporarily build from `.designspace` without instances.

