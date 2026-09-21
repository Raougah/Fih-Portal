# **Fiche**

[[DSSlab8.pdf|📄 View Fiche PDF]]
[[Guide_JSON.pdf|📄 View Guide PDF]]

## **Solution**

### **Exo**

#### json validation code

```json
{
    "$schema": "https://json-schema.org/draft-07/schema#",
    "title": "cv",
    "type": "object",
    "required": [],
    "properties": {
        "identify": {
            "type": "object",
            "required": [
                "firstName",
                "lastName",
                "email"
            ],
            "properties": {
                "firstName": {
                    "type": "string"
                },
                "lastName": {
                    "type": "string"
                },
                "email": {
                    "type": "string",
                    "format": "email"
                },
                "phone": {
                    "type": "string"
                },
                "dateOfBirth": {
                    "type": "string",
                    "format": "date"
                }
            }
        },
        "education": {
            "type": "array",
            "minItems": 1,
            "items": {
                "type": "object",
                "required": [
                    "degree",
                    "institution",
                    "year"
                ],
                "properties": {
                    "degree": {
                        "type": "string"
                    },
                    "institution": {
                        "type": "string"
                    },
                    "year": {
                        "type": "integer",
                        "minimum": 1950,
                        "maximum": 2100
                    },
                    "mention": {
                        "type": "string",
                        "enum": [
                            "Excellent",
                            "Very Good",
                            "Good",
                            "Satisfactory"
                        ]
                    }
                }
            }
        },
        "experience": {
            "type": "array",
            "required": [
                "jobTitle",
                "company",
                "startDate"
            ],
            "items": {
                "jobTitle": {
                    "type": "string"
                },
                "company": {
                    "type": "string"
                },
                "startDate": {
                    "type": "string",
                    "format": "date"
                },
                "endDate": {
                    "type": "string",
                    "format": "date"
                },
                "current": {
                    "type": "boolean",
                    "description": "Indicating whether this is the current position"
                },
                "Description": {
                    "type": "string",
                    "maxLength": 500
                }
            }
        },
        "skills": {
            "type": "array",
            "minItems": 1,
            "items": {
                "type": "string",
                "minLength": 2
            }
        }
    }
}
```
