package com.example.lab3

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.widget.ImageView
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.lab3.databinding.ActivityMainBinding
import androidx.databinding.DataBindingUtil

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    private lateinit var profilePhoto: ImageView
    private lateinit var phone: TextView
    private lateinit var email: TextView
    private lateinit var website: TextView
    private lateinit var address: TextView

    private val cameraLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == RESULT_OK) {
            // get the thumbnail photo from camera
            val photo = result.data?.extras?.get("data") as? android.graphics.Bitmap
            photo?.let { profilePhoto.setImageBitmap(it) }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        binding = DataBindingUtil.setContentView(this, R.layout.activity_main)

        setupClicks()

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    private fun setupClicks() {
        //* phone
        val phone = binding.phone
        phone.setOnClickListener {
            var intent = Intent(Intent.ACTION_DIAL).apply {
                data = Uri.parse("tel:${phone.text.toString()}")
            }
            startActivity(intent)
        }

        //* email
        email = binding.email
        email.setOnClickListener {
            val intent = Intent(Intent.ACTION_SENDTO).apply {
                data = Uri.parse("mailto:${email.text.toString()}")
            }
            startActivity(intent)
        }
        website = binding.website
        website.setOnClickListener {
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse(website.text.toString())
            }
            startActivity(intent)
        }
        address = binding.address
        address.setOnClickListener {
            val addressEncoded = Uri.encode(address.text.toString())
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("geo:0,0?q=${addressEncoded}")
            }
            startActivity(intent)
        }
        profilePhoto = binding.profilePhoto
        profilePhoto.setOnClickListener {
            val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            cameraLauncher.launch(intent)
        }


    }
}