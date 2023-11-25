def auth_headers(user)
  token = Jwt.encode({ id: user.id })
  {
    'Authorization': "Bearer #{token}"
  }
end
