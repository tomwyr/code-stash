package com.tomwyr

fun main() {
    processDefault(text = "Hi")
}

@WithDefaults
fun process(number: Number, text: String, flag: Boolean) {
    println("$number $text $flag")
}
