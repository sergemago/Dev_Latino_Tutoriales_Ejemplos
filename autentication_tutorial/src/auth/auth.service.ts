import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private readonly jwtService: JwtService) {}

  async createToken(user) {
    const payload = this.validateUser(user.username);
    return {
      access_token: this.jwtService.sign({ username: user.username, sub: user.userId},{expiresIn: '60s'}),
    };
  }

  async validateUser(body: any) {
    const user = await this.findOne(body.username);

    if (user && user.password === body.password) {
      return { username: user.username, sub: user.userId};
    }
  }

  private readonly users = [
    {
      userId: 1,
      username: 'serge',
      password: 'pass1',
    },
    {
      userId: 2,
      username: 'manuel',
      password: 'pass2',
    },
  ];

  async findOne(username: string): Promise<any | undefined> {
    return this.users.find(user => user.username === username);
  }
}