import { Controller, Get, Post, UseInterceptors, UploadedFiles, Body, Param, Res } from '@nestjs/common';
import { AnyFilesInterceptor } from '@nestjs/platform-express';
import { AppService } from './app.service';
import { diskStorage } from 'multer';
import path = require('path');
import { Observable, of } from 'rxjs';
import { join } from 'path';

export const storage = {
  storage: diskStorage({
      destination: './uploads/',
      filename: (req, file, cb) => {
          const filename: string = path.parse(file.originalname).name.replace(/\s/g, '');
          const extension: string = path.parse(file.originalname).ext;

          cb(null, `${filename}${extension}`)
      }
  })
}

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get(':filename')
  downloadFile(@Param('filename') filename, @Res() res ): Observable<Object> {
    return of(res.sendFile(join(process.cwd(), 'uploads/'+filename)));
  }
  
  @Post()
  @UseInterceptors(AnyFilesInterceptor(storage))
  async UploadMultiplesFiles(@UploadedFiles() files, @Body() Body, ) {
    console.log(Body.adicionals); 
    return {response: true};
  }

}
