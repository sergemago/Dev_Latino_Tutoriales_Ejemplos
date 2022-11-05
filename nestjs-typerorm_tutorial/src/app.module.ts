import { EstudianteModule } from './estudiante/estudiante.module';
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { join } from 'path';

@Module({
  imports: [TypeOrmModule.forRoot(
    {
    "type": "mysql",
    "host": "localhost",
    "port": 3306,
    "username": "root",
    "password": "",
    "database": "tutorial",
    "entities": [join(__dirname, '**', '*.entity.{ts,js}')],
    "synchronize": true,
}
  ), EstudianteModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
