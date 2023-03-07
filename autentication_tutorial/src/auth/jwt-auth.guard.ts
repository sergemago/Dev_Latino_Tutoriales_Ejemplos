import { ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { request } from 'http';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {

    handleRequest(err, user, info) {

        if (err || !user) {
          throw err || new UnauthorizedException();
        }
        return user;
      }

      canActivate(context: ExecutionContext) {
        // Agrega tu logica personalizada aqui
       
        return super.canActivate(context);
      }

}
