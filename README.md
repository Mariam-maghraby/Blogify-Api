# Blogify API

A Blog Application RESTful API built with Ruby on Rails, PostgreSQL, Sidekiq, Redis, and JWT-based authentication. The app allows users to signup/login, create/edit/delete posts and comments, with tag management and automatic post deletion after 24 hours.

---

## Features

- **User Authentication** (Signup/Login) using JWT
- **User Model**: `name`, `email`, `password`, `image`
- **Posts CRUD** with fields: `title`, `body`, `author(user)`, `tags`, `comments`
- Authorization: Users can only edit/delete their own posts and comments
- Users can comment on any post
- Posts must have at least one tag; tags can be updated
- Automatic post deletion after 24 hours using Sidekiq + Redis
- All API endpoints except signup/login require authentication

---

## Tech Stack

- Ruby on Rails
- PostgreSQL
- Sidekiq + Redis (for background jobs & scheduling)
- JWT (JSON Web Tokens) for API authentication
- Docker & Docker Compose for containerized development and deployment

---

## Prerequisites

- Docker & Docker Compose installed
- (Optional) `docker` and `docker-compose` commands available in your terminal

---

## Getting Started

1. **Clone the repo:**

   ```bash
   git clone https://github.com/Mariam-maghraby/Blogify-Api.git
   ```

2. **Set your Rails Master Key:**

   Create a file `config/master.key` or export your key to environment variable:

   ```bash
   export RAILS_MASTER_KEY=your_master_key_here
   ```

3. **Start the whole stack:**

   ```bash
   docker-compose up --build
   ```

   This command will build and start:

   - Rails API server (default port 3000)
   - PostgreSQL database
   - Redis server
   - Sidekiq worker

4. **API will be available at:**

   ```
   http://localhost:3000
   ```

---

## API Endpoints

### Authentication

- `POST /signup` — Register a new user
- `POST /login` — Authenticate and get JWT token

### Posts (Authenticated)

- `GET /posts` — List all posts
- `POST /posts` — Create a new post (must include at least one tag)
- `GET /posts/:id` — Get a specific post
- `PUT /posts/:id` — Update own post
- `DELETE /posts/:id` — Delete own post

### Comments (Authenticated)

- `POST /posts/:post_id/comments` — Add comment to a post
- `PUT /comments/:id` — Edit own comment
- `DELETE /comments/:id` — Delete own comment

---

## Notes

- Users can only update/delete their own posts and comments.
- Posts are automatically deleted after 24 hours of creation using Sidekiq scheduled jobs.
- All endpoints (except signup and login) require a valid JWT token in the `Authorization` header:  
  `Authorization: Bearer <token>`

---

## Development

To run migrations, seed data, or other Rails commands inside the container:

```bash
docker-compose run web rails db:create db:migrate db:seed
```

---

## Docker Compose Services

- **web** — Rails API server
- **sidekiq** — Background worker processing jobs (e.g. post deletion)
- **db** — PostgreSQL database
- **redis** — Redis server used by Sidekiq

---

## Troubleshooting

- If you make code changes, you may need to rebuild the containers:

  ```bash
  docker-compose down
  docker-compose up --build
  ```

- Ensure your `RAILS_MASTER_KEY` environment variable is set properly.

---

## Contact

For questions or contributions, please open an issue or submit a pull request.

