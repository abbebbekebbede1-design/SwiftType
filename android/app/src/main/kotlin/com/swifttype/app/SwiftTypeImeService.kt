package com.swifttype.app

import android.inputmethodservice.InputMethodService
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.content.Context
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputConnection
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.PopupWindow
import android.widget.Toast

class SwiftTypeImeService : InputMethodService() {
  private var english = false
  private var symbols = false
  private var shifted = false
  private val bg = Color.rgb(8, 11, 25)
  private val keyBg = Color.rgb(43, 46, 56)
  private val accent = Color.rgb(8, 123, 255)

  // Layout 1 follows the supplied full-grid reference; Layout 2 follows the compact
  // base-Fidel + variation reference. The mapping is an initial editable draft.
  private val layout1 = listOf(
    listOf("ሀ","ለ","ሐ","መ","ሠ","ረ","ሰ","ሸ","ቀ","በ"),
    listOf("ሁ","ሉ","ሑ","ሙ","ሡ","ሩ","ሱ","ሹ","ቁ","ቡ"),
    listOf("፡","።","፣","፤","፥","፦","፧","፨","፩","፪"),
    listOf("ኀ","ነ","ኘ","አ","ከ","ኸ","ወ","ዐ","ዘ","ዠ"),
    listOf("፡","ገ","ጠ","ጨ","ጀ","ጰ","ጸ","ፀ","ፈ")
  )
  private val layout2 = listOf(
    listOf("ሀ","ለ","ሐ","መ","ሠ","ረ","ሰ","ሸ","ቀ","በ"),
    listOf("ነ","ተ","ቸ","ኀ","ከ","ኸ","ወ","ዐ","ዘ","ዠ"),
    listOf("አ","ኡ","ኢ","ኣ","ኤ","እ","ኦ","ገ","ጠ"),
    listOf("ጨ","ጀ","ጰ","ጸ","ፀ","ፈ","ፐ")
  )
  private val variations = mapOf(
    "ሀ" to listOf("ሁ","ሂ","ሃ","ሄ","ህ","ሆ"),
    "ለ" to listOf("ሉ","ሊ","ላ","ሌ","ል","ሎ"),
    "ሐ" to listOf("ሑ","ሒ","ሓ","ሔ","ሕ","ሖ"),
    "መ" to listOf("ሙ","ሚ","ማ","ሜ","ም","ሞ"),
    "ሠ" to listOf("ሡ","ሢ","ሣ","ሤ","ሥ","ሦ"),
    "ረ" to listOf("ሩ","ሪ","ራ","ሬ","ር","ሮ"),
    "ሰ" to listOf("ሱ","ሲ","ሳ","ሴ","ስ","ሶ"),
    "ሸ" to listOf("ሹ","ሺ","ሻ","ሼ","ሽ","ሾ"),
    "ቀ" to listOf("ቁ","ቂ","ቃ","ቄ","ቅ","ቆ"),
    "በ" to listOf("ቡ","ቢ","ባ","ቤ","ብ","ቦ"),
    "ተ" to listOf("ቱ","ቲ","ታ","ቴ","ት","ቶ"),
    "ነ" to listOf("ኑ","ኒ","ና","ኔ","ን","ኖ"),
    "ከ" to listOf("ኩ","ኪ","ካ","ኬ","ክ","ኮ"),
    "ወ" to listOf("ዉ","ዊ","ዋ","ዌ","ው","ዎ"),
    "አ" to listOf("ኡ","ኢ","ኣ","ኤ","እ","ኦ")
  )

  override fun onCreateInputView(): View = buildKeyboard()

  private fun buildKeyboard(): View {
    val root = LinearLayout(this).apply {
      orientation = LinearLayout.VERTICAL
      setPadding(dp(7), dp(7), dp(7), dp(7))
      setBackgroundColor(bg)
    }
    val toolbar = LinearLayout(this).apply { gravity = Gravity.CENTER; orientation = LinearLayout.HORIZONTAL }
    listOf("☺", "⇄", "▣", "⚙", "•••").forEachIndexed { index, label ->
      val item = key(label, 42, false) {
        when(index) {
          1 -> { english = !english; setInputView(buildKeyboard()) }
          2 -> { val p = currentInputConnection; p?.commitText("", 1) }
          3 -> Toast.makeText(this, "Change keyboard options in SwiftType app", Toast.LENGTH_SHORT).show()
          4 -> { symbols = !symbols; setInputView(buildKeyboard()) }
        }
      }
      toolbar.addView(item, LinearLayout.LayoutParams(0, dp(52), 1f))
    }
    root.addView(toolbar)
    val rows = if (english) englishRows() else if (symbols) symbolRows() else {
      val selected = getSharedPreferences("swifttype_ime", Context.MODE_PRIVATE).getString("amharic_layout", "Layout 2")
      if (selected == "Layout 1") layout1 else layout2
    }
    rows.forEachIndexed { rowIndex, row ->
      val line = LinearLayout(this).apply { gravity = Gravity.CENTER; orientation = LinearLayout.HORIZONTAL }
      row.forEach { value ->
        val main = key(value, if (row.size <= 7) 48 else 43, true) { commit(value) }
        if (!english && !symbols && rowIndex < 3 && variations.containsKey(value)) {
          main.setOnLongClickListener { showVariations(value, variations[value]!!); true }
          main.text = value
        }
        line.addView(main, LinearLayout.LayoutParams(0, dp(54), 1f).apply {
          setMargins(dp(2), dp(3), dp(2), dp(3))
        })
      }
      root.addView(line)
    }
    val bottom = LinearLayout(this).apply { gravity = Gravity.CENTER; orientation = LinearLayout.HORIZONTAL }
    bottom.addView(key(if (symbols) "ABC" else "!#1", 48, false) { symbols = !symbols; setInputView(buildKeyboard()) },
      LinearLayout.LayoutParams(0, dp(52), 1.2f))
    bottom.addView(key("🌐", 40, false) { english = !english; setInputView(buildKeyboard()) },
      LinearLayout.LayoutParams(0, dp(52), 1f))
    bottom.addView(key(",", 36, false) { commit(",") }, LinearLayout.LayoutParams(0, dp(52), .8f))
    bottom.addView(key(if (english) "English" else "አማርኛ", 18, true) { commit(" ") },
      LinearLayout.LayoutParams(0, dp(52), 3.7f))
    bottom.addView(key(".", 36, false) { commit(".") }, LinearLayout.LayoutParams(0, dp(52), .8f))
    bottom.addView(key("↵", 38, true) { currentInputConnection?.sendKeyEvent(android.view.KeyEvent(android.view.KeyEvent.ACTION_DOWN, android.view.KeyEvent.KEYCODE_ENTER)); currentInputConnection?.sendKeyEvent(android.view.KeyEvent(android.view.KeyEvent.ACTION_UP, android.view.KeyEvent.KEYCODE_ENTER)) },
      LinearLayout.LayoutParams(0, dp(52), 1.2f))
    root.addView(bottom)
    return root
  }

  private fun englishRows(): List<List<String>> {
    val rows = listOf(
      listOf("q","w","e","r","t","y","u","i","o","p"),
      listOf("a","s","d","f","g","h","j","k","l"),
      listOf("⇧","z","x","c","v","b","n","m","⌫")
    )
    return if (shifted) rows.map { row -> row.map { if (it.length == 1 && it[0].isLetter()) it.uppercase() else it } } else rows
  }
  private fun symbolRows() = listOf(
    listOf("1","2","3","4","5","6","7","8","9","0"),
    listOf("@","#","$","%","&","-","+","(",")","/"),
    listOf("*","\"","' ",":",";","!","?","⌫")
  )

  private fun key(label: String, size: Int, prominent: Boolean, action: () -> Unit): TextView {
    return TextView(this).apply {
      text = label
      textSize = if (label.length > 2) 15f else if (label == "🌐") 22f else 24f
      gravity = Gravity.CENTER
      setTextColor(Color.WHITE)
      typeface = Typeface.create("sans-serif", Typeface.NORMAL)
      background = GradientDrawable().apply {
        setColor(if (prominent) keyBg else Color.rgb(31, 35, 49))
        cornerRadius = dp(8).toFloat()
      }
      isClickable = true
      setOnClickListener {
        when(label) {
          "⌫" -> currentInputConnection?.deleteSurroundingText(1, 0)
          "⇧" -> { shifted = !shifted; setInputView(buildKeyboard()) }
          else -> action()
        }
      }
    }
  }

  private fun showVariations(base: String, options: List<String>) {
    val popupContent = LinearLayout(this).apply {
      orientation = LinearLayout.HORIZONTAL
      setBackgroundColor(Color.rgb(30, 35, 52))
      setPadding(dp(5), dp(5), dp(5), dp(5))
    }
    options.forEach { option ->
      val v = TextView(this).apply {
        text = option; textSize = 23f; gravity = Gravity.CENTER; setTextColor(Color.WHITE)
        setPadding(dp(9), dp(10), dp(9), dp(10))
        setOnClickListener { commit(option); popup.dismiss() }
      }
      popupContent.addView(v)
    }
    lateinit var popup: PopupWindow
    popup = PopupWindow(popupContent, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, true)
    popup.elevation = dp(8).toFloat()
    val anchor = getInputView() ?: popupContent
    popup.showAtLocation(anchor, Gravity.TOP or Gravity.CENTER_HORIZONTAL, 0, dp(12))
  }

  private fun commit(text: String) { currentInputConnection?.commitText(text, 1) }
  private fun dp(v: Int) = (v * resources.displayMetrics.density).toInt()
}
