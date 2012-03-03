/*******************************************************************************
*                                                                              *
*  Stack implementation.                                                       *
*                                                                              *
*  by Kirill Chuvilin aka KiRiK, kirik-ch.ru                                   *
*                                                                              *
*******************************************************************************/

var array = new Array()

function isEmpty() {
    return array.length <= 0
}

function push(data) {
    array.push(data)
}

function pop() {
    return array.pop()
}
