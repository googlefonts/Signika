const fontTest = document.querySelector(".font-test")
const swapButton = document.querySelector("#swap-fonts")
const swapColors = document.querySelector("#swap-colors")
const fontName = document.querySelector(".font-name")
const fontWght = document.querySelector("#font-weight")

var fontNegative = false
var colorNegative = false
var colorsSwapActive = false

function colorCheckboxHandler() {
    colorsSwapActive = !colorsSwapActive;
    console.log("colorsSwapActive is " + colorsSwapActive)
    if (colorsSwapActive === true) {
        swapButton.innerHTML = "Fonts & Colors"
    } else {
        swapButton.innerHTML = "Swap Fonts"
    }

}

function swapColorsHandler() {
    colorNegative = !colorNegative;
    if (colorNegative === true) {
        fontTest.classList.toggle("negative-colors")
    }
}

function swapButtonHandler() {
    fontNegative = !fontNegative;

    console.log("fontNegative is " + fontNegative);
    if (fontNegative === true) {
        fontTest.classList.add("negative")
        fontName.innerHTML = "Signika Negative"
    } else {
        fontTest.classList.remove("negative")
        fontTest.classList.remove("negative-colors")
        fontName.innerHTML = "Signika"
    }

    if (colorsSwapActive === true) {
        swapColorsHandler()
    }
}

// setFontWeight

// fontWght => {
//     fontTest.style = `--fontWght: ${fontWght.value}`
// }
const setFontWght = (menu) => {
    console.log(menu.value)
    fontTest.style = `--fontWght: ${menu.value}`
}

setFontWght(fontWght)

function weightMenuHandler(e) {
    console.log(e.srcElement.value)
    fontTest.style = `--fontWght: ${e.srcElement.value}`
}


swapButton.addEventListener("click", swapButtonHandler)

swapColors.addEventListener("change", colorCheckboxHandler)

fontWght.addEventListener("change", weightMenuHandler)