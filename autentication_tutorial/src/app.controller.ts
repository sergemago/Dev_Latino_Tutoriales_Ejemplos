import { Controller, Get , UseGuards, Request} from '@nestjs/common';
import { AppService } from './app.service';
import { JwtAuthGuard } from './auth/jwt-auth.guard';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @UseGuards(JwtAuthGuard)
  @Get('hello')
  getHello(@Request() req): string {
    return this.appService.getHello() +" "+ req.user.username;
  }
}
