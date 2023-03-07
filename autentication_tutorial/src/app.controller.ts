import { Controller, Get, Req, UseGuards , Request} from '@nestjs/common';
import { AppService } from './app.service';
import { JwtAuthGuard } from './auth/jwt-auth.guard';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  getHello(@Request() req) {
    return this.appService.getHello()+" "+ req.user.username;
  }

}
