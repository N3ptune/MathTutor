# 📊 Baseline Monthly Cost Estimate (MVP / Prototype)

This assumes:

- 100 active users  
- Light usage (50–200 AI-evaluated math problems per day)  
- React frontend, Python backend, PostgreSQL, OpenAI API, Firebase Auth, AWS hosting, GitHub CI/CD  

| Component | Service Used | Estimated Monthly Cost | Notes |
|----------|--------------|------------------------|-------|
| **Frontend Hosting** | AWS S3 + CloudFront | **$3 – $10** | Static hosting + CDN |
| **Backend Compute** | AWS EC2 (t3.small) or ECS Fargate | **$15 – $40** | Runs FastAPI + LangChain |
| **Database** | AWS RDS PostgreSQL (db.t3.micro) | **$15 – $50** | Includes automated backups |
| **Object Storage** | AWS S3 | **$1 – $5** | Stores user files, images, exports |
| **Authentication** | Firebase Auth | **$0** | Free tier covers 10k MAU |
| **AI Usage** | OpenAI API | **$20 – $150** | Depends on number of math evaluations |
| **CI/CD Pipeline** | GitHub Actions | **$0** | Free tier often enough |
| **Monitoring & Logs** | AWS CloudWatch | **$2 – $10** | Basic logging/metrics |
| **Domain + SSL** | Route 53 | **$1 – $12** | Domain registration + hosted zone |

## **Total Estimated Cost (MVP Stage)**

💰 **$60 – $240 per month**
