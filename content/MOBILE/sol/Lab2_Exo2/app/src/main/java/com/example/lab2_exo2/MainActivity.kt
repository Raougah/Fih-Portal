package com.example.lab2_exo2

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity : AppCompatActivity() {
    //* properties declaration
    private lateinit var value: TextView
    private var counter: Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContentView(R.layout.activity_main)

        //* init
        value = findViewById<TextView>(R.id.value)
        //* methods
        increment()
        decrement()

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    private fun increment() {
        val addBtn = findViewById<Button>(R.id.add)
        addBtn.setOnClickListener {
            counter++
            value.text = (counter).toString()
        }
    }

    private fun decrement() {
        val addBtn = findViewById<Button>(R.id.minus)
        addBtn.setOnClickListener {
            counter--
            value.text = (counter).toString()
        }
    }
}
