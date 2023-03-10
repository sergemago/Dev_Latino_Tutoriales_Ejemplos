/*
https://docs.nestjs.com/providers#services
*/

import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
    constructor(private readonly jwtService: JwtService) {}

    async createToken(user) {
        
      const payload = await this.validateUser(user);
      return {
        access_token: this.jwtService.sign({username: payload.username, sub: payload.sub}, {expiresIn: '120s'})
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
