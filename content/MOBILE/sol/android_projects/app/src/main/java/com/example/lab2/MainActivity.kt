package com.example.lab2

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity : AppCompatActivity() {
    //* Attributes
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // enables full screen edge to edge (content goes under status bar)
        enableEdgeToEdge()

        // loads activity_main.xml as the screen
        setContentView(R.layout.activity_main)

        //* call methods
        chnageAuthorName()

        // adds padding so content doesn't hide behind status bar/nav bar
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    private fun chnageAuthorName() {
        val btn = findViewById<Button>(R.id.btnAuthor)
        val author = findViewById<TextView>(R.id.author)
        btn.setOnClickListener {
            showToast(author.text.toString())
            author.text = "hhhhh"
        }
    }

    private fun showToast(authorName: String) {
        Toast.makeText(this, authorName, Toast.LENGTH_SHORT).show()
    }
}